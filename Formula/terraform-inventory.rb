class TerraformInventory < Formula
  desc "Terraform State → Ansible Dynamic Inventory"
  homepage "https://github.com/adammck/terraform-inventory"
  url "https://github.com/adammck/terraform-inventory/archive/v0.10.tar.gz"
  sha256 "8bd8956da925d4f24c45874bc7b9012eb6d8b4aa11cfc9b6b1b7b7c9321365ac"
  license "MIT"
  head "https://github.com/adammck/terraform-inventory.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1acd7cb77565f8b7838a0421529c24e48d2f703e0ec8d180f3b3f0a8bdb308f8"
    sha256 cellar: :any_skip_relocation, big_sur:       "d17cfd5dce0dfbc136f1508da7c24894edf479492698be1e7fecd0787d6aefed"
    sha256 cellar: :any_skip_relocation, catalina:      "a645460f72cd2fb823d603325439b39a7b8c493a2c3b833d87a484bbc0dfe7ba"
    sha256 cellar: :any_skip_relocation, mojave:        "9f34bba5205c0fc87ddf7c95ce8532b85fc7cbb515dea9cc211f70fab2aeb643"
    sha256 cellar: :any_skip_relocation, high_sierra:   "a9500dab587c5078fe62ae2ab5eff2376ecad8d29208a60fe195debfdeea5e78"
    sha256 cellar: :any_skip_relocation, sierra:        "6b30bf29fe2e83c3bb75c16ce83731c7b212f5f48c3db787501cf1fbb8c37d19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "245a07df6c433118da995d18a1133e96566f8a9cc52546a0a405fae0372c91a3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.build_version=#{version}")
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
