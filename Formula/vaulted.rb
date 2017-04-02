require "language/go"

class Vaulted < Formula
  desc "Allows the secure storage and execution of environments"
  homepage "https://github.com/miquella/vaulted"
  url "https://github.com/miquella/vaulted/archive/v2.1.tar.gz"
  sha256 "237cce6a48eca2c7fba311da05da657ed5924bf2ee7065f718705166131b70c4"

  head "https://github.com/miquella/vaulted.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aad9ffdbbb5356abd6688d46903bf875d80d262b1c6aea3363126436c6cd404a" => :sierra
    sha256 "3e6e5f2ce11c77a2c6c71c0bacfeba70e70923d85155568023af6247808daf8f" => :el_capitan
    sha256 "a8dbba82a1f0ac3cf134a4ec47d802c1ce8c0143b071a3163be7108d1373d62f" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/aws/aws-sdk-go" do
    url "https://github.com/aws/aws-sdk-go.git",
        :revision => "94673f7d41219ea3e94e4b1edc01315f14268f72"
  end

  go_resource "github.com/chzyer/readline" do
    url "https://github.com/chzyer/readline.git",
    :revision => "62c6fe6193755f722b8b8788aa7357be55a50ff1"
  end

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
        :revision => "87d4004f2ab62d0d255e0a38f1680aa534549fe3"
  end

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
        :revision => "ed8eb9e318d7a84ce5915b495b7d35e0cfe7b5a8"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
        :revision => "3a115632dcd687f9c8cd01679c83a06a0e21c1f3"
  end

  go_resource "github.com/miquella/ask" do
    url "https://github.com/miquella/ask.git",
        :revision => "486a722fa4cdb033d35a501d54116b645e139ef3"
  end

  go_resource "github.com/miquella/xdg" do
    url "https://github.com/miquella/xdg.git",
        :revision => "1ee6df0d556245ee71d26d54f9dbfea1f84d136a"
  end

  go_resource "github.com/spf13/pflag" do
    url "https://github.com/spf13/pflag.git",
        :revision => "4f9190456aed1c2113ca51ea9b89219747458dc1"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "9fbab14f903f89e23047b5971369b86380230e56"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/miquella"
    ln_s buildpath, "src/github.com/miquella/vaulted"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", bin/"vaulted", "github.com/miquella/vaulted"
    man1.install Dir["doc/man/vaulted*.1"]
  end

  test do
    (testpath/".local/share/vaulted").mkpath
    touch(".local/share/vaulted/test_vault")
    output = IO.popen(["#{bin}/vaulted", "ls"], &:read)
    output == "test_vault\n"
  end
end
