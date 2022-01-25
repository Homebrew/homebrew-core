require "language/node"
class TerraformRover < Formula
  desc "Terraform Visualizer"
  homepage "https://github.com/im2nguyen/rover"
  url "https://github.com/im2nguyen/rover/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "9f04708e30770000116c5e00ffc9307812177d0049854c0f28139c478653d7fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3412ce96504fca6f97e7d041c06ea24a83969e03e0a5881b17196821c9a4d14e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4cb3a9c5cc5f962b6cba348de4223ed38d43447ab7d7b1e307de00aa8c83154f"
    sha256 cellar: :any_skip_relocation, monterey:       "0e6f0533ac17e4171553c1c3451beef2efe7520cabe2e79738312fa2dcdeab0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "57d45f46ff3c9a782680138a46ce2de96e784f40492dda446f3181d6279c969b"
    sha256 cellar: :any_skip_relocation, catalina:       "37d1af5fad6d3192ba56c1b6ae2b8c0da9f20b96d3f0c09a840d00bd5ef80095"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2186246152a9c36aaf4cbdb54b51ad37bceedca3e268131df54c06e053a43ac5"
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
