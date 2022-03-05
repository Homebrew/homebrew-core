require "language/node"
class TerraformRover < Formula
  desc "Terraform Visualizer"
  homepage "https://github.com/im2nguyen/rover"
  url "https://github.com/im2nguyen/rover/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "c49a840030f4f864c1b360f09a50917f9b4ffda08a1ba4834d1c1e3d5b9d152e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9eb9869e672b22066b7c186dedb0393ba18594cf891d7ff13243613ed8958b6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdfa617e5a3e4a14b1c5f6a89df7a00d9245915ac06c09ad9ae648f32d8a5920"
    sha256 cellar: :any_skip_relocation, monterey:       "0cecc4597bd5e26dbf4a4d54727c9ec38fe4e2ac370d0ced7b5bed0d21b2189a"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf582669d5812b7653e54a21d557262f9f59adf25979bfe7129c196d9296df9f"
    sha256 cellar: :any_skip_relocation, catalina:       "cda8e2eda157753545a3fe8e23e62edae429d909176f127cdc13a60d297bf329"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18de38ac4aa78e17a731f9914457d52d863fc7c8fd3a9b87627da96d5be9591c"
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
