require "language/node"
class TerraformRover < Formula
  desc "Terraform Visualizer"
  homepage "https://github.com/im2nguyen/rover"
  url "https://github.com/im2nguyen/rover/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "91dc4ff26e0adafde011db1e6111a8a3c545cddbae1a70c8f4c3abc484b0be0b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a074f14618b6eb3f4fa1f3538508322aeff9a4aafb6e13176a3ceaab56dcd8ea"
    sha256 cellar: :any_skip_relocation, big_sur:       "cb2dc4dab8d77371813992ead874a94223269ee42f489d95846a0be627adc9ea"
    sha256 cellar: :any_skip_relocation, catalina:      "13de4d7c616eb75498f5f633025a6db46cd436d37386a5f94a97d120564fcb72"
    sha256 cellar: :any_skip_relocation, mojave:        "865c313e1f50c9da29fc570cc602727cf222050b337ab8e61b35ed544be145bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64b4259285d662de26aec694874b0503ec05edc271915f8535c3b1b2afd35080"
  end

  depends_on "go" => :build
  depends_on "node"
  depends_on "terraform"

  def install
    Language::Node.setup_npm_environment
    cd "ui" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
    end
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"main.tf").write <<~EOS
      output "hello_world" {
        value = "Hello, World!"
      }
    EOS
    system bin/"terraform-rover", "-standalone", "-tfPath", Formula["terraform"].bin/"terraform"
    assert_predicate testpath/"rover.zip", :exist?
  end
end
