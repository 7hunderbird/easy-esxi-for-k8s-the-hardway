# ova

1. Go to <https://cloud-images.ubuntu.com/resolute/> and download an ova file.
1. Put the file in this folder, git will ignore it.
1. Configure the `ova_path` in the `terraform.tfvars` file to match the downloaded file. For example:

```tf
ovf_path = "ova/resolute-server-cloudimg-amd64.ova"
```
