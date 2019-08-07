require "language/go"

class TerraformInventory < Formula
  desc "Terraform State → Ansible Dynamic Inventory"
  homepage "https://github.com/adammck/terraform-inventory"
  url "https://github.com/adammck/terraform-inventory/archive/v0.9.tar.gz"
  sha256 "e0f5876b2272ac3f9702e3599078aede1e448f617526beec147cd3fbbf0836bd"
  head "https://github.com/adammck/terraform-inventory.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "203c02568b64c714d4a0d3d1d4c79145c44cce26530e71873ca0ba9d9d828028" => :mojave
    sha256 "420ed8fc7e9b153c62d269f3be50c1f5d3031bad6eadaa01075a60718cd2e105" => :high_sierra
    sha256 "6fb9cb51d18faa3f5cdedf0986467bb5b88fd72c422f00950a76b6bb5e93a082" => :sierra
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
