import streamlit as st
import pandas as pd
import plotly.express as px

st.set_page_config(page_title="E-commerce Sales Dashboard", layout="wide", page_icon="🛒")

@st.cache_data
def load_data():
    df = pd.read_csv("superstore_sales.csv", encoding="latin1")
    df.columns = [c.strip().replace(" ", "_").replace("-", "_") for c in df.columns]
    df["Order_Date"] = pd.to_datetime(df["Order_Date"], format="%m/%d/%Y")
    df["Order_Year"] = df["Order_Date"].dt.year
    df["Order_Month"] = df["Order_Date"].dt.month
    return df

df = load_data()

st.title("🛒 E-commerce Sales Performance Dashboard")
st.markdown("Interactive analysis of the **Superstore Sales** dataset — 8,399 orders (2009–2012)")

# ---------------- Sidebar filters ----------------
st.sidebar.header("Filters")
years = sorted(df["Order_Year"].unique())
selected_years = st.sidebar.multiselect("Order Year", years, default=years)

regions = sorted(df["Region"].unique())
selected_regions = st.sidebar.multiselect("Region", regions, default=regions)

categories = sorted(df["Product_Category"].unique())
selected_categories = st.sidebar.multiselect("Product Category", categories, default=categories)

filtered = df[
    df["Order_Year"].isin(selected_years)
    & df["Region"].isin(selected_regions)
    & df["Product_Category"].isin(selected_categories)
]

if filtered.empty:
    st.warning("No data matches the selected filters. Please adjust your selection.")
    st.stop()

# ---------------- KPI row ----------------
total_sales = filtered["Sales"].sum()
total_profit = filtered["Profit"].sum()
margin = (total_profit / total_sales * 100) if total_sales else 0
total_orders = len(filtered)
loss_orders = (filtered["Profit"] < 0).sum()

col1, col2, col3, col4, col5 = st.columns(5)
col1.metric("Total Revenue", f"${total_sales:,.0f}")
col2.metric("Total Profit", f"${total_profit:,.0f}")
col3.metric("Profit Margin", f"{margin:.2f}%")
col4.metric("Total Orders", f"{total_orders:,}")
col5.metric("Loss-Making Orders", f"{loss_orders:,} ({loss_orders/total_orders*100:.1f}%)")

st.divider()

# ---------------- Charts ----------------
tab1, tab2, tab3, tab4 = st.tabs(["📦 By Category", "🌍 By Region", "📈 Trend", "💸 Discount Impact"])

with tab1:
    c1, c2 = st.columns(2)
    cat_sales = filtered.groupby("Product_Category", as_index=False)["Sales"].sum().sort_values("Sales", ascending=False)
    fig1 = px.bar(cat_sales, x="Product_Category", y="Sales", title="Revenue by Product Category",
                  color="Product_Category", text_auto=".2s")
    c1.plotly_chart(fig1, use_container_width=True)

    sub = filtered.groupby("Product_Sub_Category", as_index=False)["Sales"].sum().sort_values("Sales", ascending=False).head(10)
    fig2 = px.bar(sub, x="Sales", y="Product_Sub_Category", orientation="h", title="Top 10 Sub-Categories by Revenue")
    fig2.update_layout(yaxis={"categoryorder": "total ascending"})
    c2.plotly_chart(fig2, use_container_width=True)

with tab2:
    reg = filtered.groupby("Region", as_index=False).agg(Sales=("Sales", "sum"), Profit=("Profit", "sum"))
    reg["Margin_Pct"] = (reg["Profit"] / reg["Sales"] * 100).round(2)
    c1, c2 = st.columns(2)
    fig3 = px.bar(reg.sort_values("Sales", ascending=False), x="Region", y="Sales", title="Revenue by Region", color="Region")
    c1.plotly_chart(fig3, use_container_width=True)
    fig4 = px.bar(reg.sort_values("Margin_Pct", ascending=False), x="Region", y="Margin_Pct", title="Profit Margin (%) by Region", color="Region")
    c2.plotly_chart(fig4, use_container_width=True)

with tab3:
    yearly = filtered.groupby("Order_Year", as_index=False).agg(Sales=("Sales", "sum"), Profit=("Profit", "sum"))
    fig5 = px.line(yearly, x="Order_Year", y=["Sales", "Profit"], markers=True, title="Yearly Sales & Profit Trend")
    st.plotly_chart(fig5, use_container_width=True)

    monthly = filtered.groupby(["Order_Year", "Order_Month"], as_index=False)["Sales"].sum()
    monthly["Period"] = monthly["Order_Year"].astype(str) + "-" + monthly["Order_Month"].astype(str).str.zfill(2)
    fig6 = px.line(monthly.sort_values("Period"), x="Period", y="Sales", title="Monthly Sales Trend")
    fig6.update_xaxes(tickangle=45)
    st.plotly_chart(fig6, use_container_width=True)

with tab4:
    def band(d):
        if d == 0:
            return "No Discount"
        elif d <= 0.1:
            return "Low (0-10%)"
        elif d <= 0.3:
            return "Medium (10-30%)"
        else:
            return "High (30%+)"

    filtered_copy = filtered.copy()
    filtered_copy["Discount_Band"] = filtered_copy["Discount"].apply(band)
    order = ["No Discount", "Low (0-10%)", "Medium (10-30%)", "High (30%+)"]
    disc = filtered_copy.groupby("Discount_Band", as_index=False)["Profit"].mean().round(2)
    disc["Discount_Band"] = pd.Categorical(disc["Discount_Band"], categories=order, ordered=True)
    disc = disc.sort_values("Discount_Band")

    c1, c2 = st.columns(2)
    fig7 = px.bar(disc, x="Discount_Band", y="Profit", title="Average Profit by Discount Band", color="Discount_Band")
    c1.plotly_chart(fig7, use_container_width=True)

    fig8 = px.scatter(filtered_copy.sample(min(2000, len(filtered_copy))), x="Discount", y="Profit",
                       title="Discount vs Profit (sampled)", opacity=0.5)
    c2.plotly_chart(fig8, use_container_width=True)

st.divider()

with st.expander("🔍 View Raw Filtered Data"):
    st.dataframe(filtered, use_container_width=True)
    st.download_button("Download filtered data as CSV", filtered.to_csv(index=False).encode("utf-8"),
                        "filtered_superstore_data.csv", "text/csv")

st.caption("Data source: Superstore Sales dataset (public practice dataset) · Built with Streamlit")
