class TerraformInventory < Formula
  desc "Go app which generates a dynamic Ansible inventory from a Terraform state file"
  homepage "https://github.com/adammck/terraform-inventory"
  url "https://github.com/adammck/terraform-inventory/archive/refs/tags/v0.10.tar.gz"
  sha256 "8bd8956da925d4f24c45874bc7b9012eb6d8b4aa11cfc9b6b1b7b7c9321365ac"
  license "MIT"
  head "https://github.com/adammck/terraform-inventory.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "bcdc79974fa55bb1087fe38999c01b1136c56f0b733706bf9b87fb937e81aa9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8779884bc89245540e8bca1eae1ff1205e9dcfb406b2b306a5488cdc161547bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45e0a0a0852cc89534be9dc22760628b624e1e085d25b6a30bcd6ec1f25fb9d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49d755bc67a9ac995c186a4143723379d87ef43ea76018706302aad4ac135efe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a1c36c1ddf616cee16ffaa7686fee0dc5043142c5aac0b95698b0caafe67c50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df26181ba3116beae2b5582eb6725c2c8d9ddad018be827f6d07d252cfc019c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "4724f1231e34d9c006f69df14a35683a750407d6b3cfa92775f41e289a645804"
    sha256 cellar: :any_skip_relocation, ventura:        "c704f37b60a3427858da569809b96102c32817bb88f17027f2d2e579e3e7ace7"
    sha256 cellar: :any_skip_relocation, monterey:       "7444adf6b3ea13567454c7ef34feebc5d5fddedeaefe5be07382544ebf67d79b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab56b7c132afc5508e5e10cfa21b784aa2f84fa8a23d9985b7b45eb04c8bdae1"
    sha256 cellar: :any_skip_relocation, catalina:       "ab56b7c132afc5508e5e10cfa21b784aa2f84fa8a23d9985b7b45eb04c8bdae1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "81cac3290ff42bd1c1759d9596b08e9647533f202dfabf5b9ad91e44a6f696bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "853cf36916d4bb9834f0f6b491e347a109a2930d350a1a31b8e7b8233720c20b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.build_version=#{version}")
  end

  test do
    example = <<~JSON
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
    JSON
    (testpath/"example.tfstate").write(example)
    assert_match(/example_instance/, shell_output("#{bin}/terraform-inventory --list example.tfstate"))
  end
end
