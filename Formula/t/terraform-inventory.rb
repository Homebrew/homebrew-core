class TerraformInventory < Formula
  desc "Terraform State → Ansible Dynamic Inventory"
  homepage "https://github.com/adammck/terraform-inventory"
  url "https://github.com/adammck/terraform-inventory/archive/v0.10.tar.gz"
  sha256 "8bd8956da925d4f24c45874bc7b9012eb6d8b4aa11cfc9b6b1b7b7c9321365ac"
  license "MIT"
  head "https://github.com/adammck/terraform-inventory.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49d755bc67a9ac995c186a4143723379d87ef43ea76018706302aad4ac135efe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a1c36c1ddf616cee16ffaa7686fee0dc5043142c5aac0b95698b0caafe67c50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df26181ba3116beae2b5582eb6725c2c8d9ddad018be827f6d07d252cfc019c0"
    sha256 cellar: :any_skip_relocation, ventura:        "c704f37b60a3427858da569809b96102c32817bb88f17027f2d2e579e3e7ace7"
    sha256 cellar: :any_skip_relocation, monterey:       "7444adf6b3ea13567454c7ef34feebc5d5fddedeaefe5be07382544ebf67d79b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab56b7c132afc5508e5e10cfa21b784aa2f84fa8a23d9985b7b45eb04c8bdae1"
    sha256 cellar: :any_skip_relocation, catalina:       "ab56b7c132afc5508e5e10cfa21b784aa2f84fa8a23d9985b7b45eb04c8bdae1"
    sha256 cellar: :any_skip_relocation, mojave:         "ab56b7c132afc5508e5e10cfa21b784aa2f84fa8a23d9985b7b45eb04c8bdae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "853cf36916d4bb9834f0f6b491e347a109a2930d350a1a31b8e7b8233720c20b"
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
