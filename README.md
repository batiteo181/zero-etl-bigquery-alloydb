# Zero-ETL Data Federation: Kết nối và Truy vấn Liên kết giữa BigQuery và AlloyDB

## 📌 Tổng quan dự án
Dự án này triển khai kiến trúc **Zero-ETL Data Federation** (Liên kết dữ liệu không qua quá trình trích xuất, chuyển đổi, nạp truyền thống) trên nền tảng **Google Cloud Platform (GCP)**. Mục tiêu là thiết lập luồng truy vấn hai chiều thời gian thực giữa kho dữ liệu phân tích (**BigQuery**) và hệ quản trị cơ sở dữ liệu vận hành mã nguồn mở hiệu năng cao (**AlloyDB cho PostgreSQL**). 

Giải pháp này giúp loại bỏ độ trễ của các đường ống dẫn dữ liệu (Data Pipelines) thông thường, tối ưu hóa chi phí lưu trữ vật lý và cho phép kết hợp dữ liệu vận hành trực tiếp với dữ liệu phân tích lịch sử để đưa ra quyết định tức thì.

## 🛠 Công nghệ áp dụng
* **Analytics Data Warehouse:** Google BigQuery
* **Operational Database:** AlloyDB for PostgreSQL
* **Data Federation Technologies:** BigQuery External Connections, PostgreSQL Foreign Data Wrappers (`bigquery_fdw`)
* **Networking:** VPC Peering, Private Services Access (PSA)
* **Infrastructure Management:** Google Cloud CLI (`gcloud`, `bq`)
* **CI/CD & Code Quality:** GitHub Actions, SQLFluff Linter

## 🏗 Kiến trúc giải pháp (Architecture Overview)
Luồng dữ liệu và thiết lập hệ thống được triển khai qua hai cơ chế bổ trợ:
1.  **Federated Query (BigQuery -> AlloyDB):** Đứng từ BigQuery Studio sử dụng hàm `EXTERNAL_QUERY()` để quét dữ liệu giao dịch thời gian thực trong mạng riêng ảo của AlloyDB mà không cần đồng bộ hóa vật lý.
2.  **Foreign Data Wrapper (AlloyDB -> BigQuery):** Kích hoạt extension `bigquery_fdw` trên AlloyDB tạo các "Bảng ngoại vi" (Foreign Tables) ánh xạ trực tiếp các tập dữ liệu lớn từ BigQuery về môi trường Postgres để phục vụ các ứng dụng phía ứng dụng (Backend Apps).

---

## 🚀 Các bước triển khai chi tiết

### Bước 1: Khởi tạo Hạ tầng Mạng và Cụm AlloyDB
Thiết lập mạng nội bộ (VPC Peering) bắt buộc vì AlloyDB hoạt động hoàn toàn trên dải IP riêng (Private IP) nhằm bảo mật dữ liệu.

```bash
# Cấu hình dải IP tĩnh phục vụ VPC Peering kết nối dịch vụ Google quản lý
gcloud compute addresses create alloydb-private-ip-range \
    --global \
    --purpose=VPC_PEERING \
    --addresses=10.20.0.0 \
    --prefix-length=16 \
    --network=default

# Thiết lập kết nối VPC Peering
gcloud services vpc-peerings connect \
    --service=servicenetworking.googleapis.com \
    --ranges=alloydb-private-ip-range \
    --network=default

# Khởi tạo AlloyDB Cluster và Primary Instance (Cấu hình 4 vCPU)
gcloud alloydb clusters create alloydb-froyo-cluster \
    --password=YOUR_SECURE_PASSWORD \
    --network=default \
    --region=us-central1

gcloud alloydb instances create alloydb-froyo-instance-primary \
    --cluster=alloydb-froyo-cluster \
    --instance-type=PRIMARY \
    --cpu-count=4 \
    --region=us-central1
```
