require "language/go"

class TerraformInventory < Formula
  desc "Terraform State → Ansible Dynamic Inventory"
  homepage "https://github.com/adammck/terraform-inventory"
  url "https://github.com/adammck/terraform-inventory/archive/v0.9.tar.gz"
  sha256 "e0f5876b2272ac3f9702e3599078aede1e448f617526beec147cd3fbbf0836bd"
  head "https://github.com/adammck/terraform-inventory.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f34bba5205c0fc87ddf7c95ce8532b85fc7cbb515dea9cc211f70fab2aeb643" => :mojave
    sha256 "a9500dab587c5078fe62ae2ab5eff2376ecad8d29208a60fe195debfdeea5e78" => :high_sierra
    sha256 "6b30bf29fe2e83c3bb75c16ce83731c7b212f5f48c3db787501cf1fbb8c37d19" => :sierra
  end

  depends_on "go" => :build

  go_resource "github.com/adammck/venv" do
    url "https://github.com/adammck/venv.git",
        :revision => "8a9c907a37d36a8f34fa1c5b81aaf80c2554a306"
  end

  go_resource "github.com/blang/vfs" do
    url "https://github.com/blang/vfs.git",
        :revision => "2c3e2278e174a74f31ff8bf6f47b43ecb358a870"
  end

  def install
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/github.com/adammck/"
    ln_sf buildpath, buildpath/"src/github.com/adammck/terraform-inventory"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", bin/"terraform-inventory", "-ldflags", "-X main.build_version='#{version}'"
  end

  test do
    example = <<~EOS
      {
          "version": 1,
          "serial": 1,
          "modules": [
              {
                  "path": [
                      "root"
                  ],
                  "outputs": {},
                  "resources": {
                      "aws_instance.example_instance": {
                          "type": "aws_instance",
                          "primary": {
                              "id": "i-12345678",
                              "attributes": {
                                  "public_ip": "1.2.3.4"
                              },
                              "meta": {
                                  "schema_version": "1"
                              }
                          }
                      }
                  }
              }
          ]
      }
    EOS
    (testpath/"example.tfstate").write(example)
    assert_match(/example_instance/, shell_output("#{bin}/terraform-inventory --list example.tfstate"))
  end
end
