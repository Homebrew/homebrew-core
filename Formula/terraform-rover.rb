require "language/node"
class TerraformRover < Formula
  desc "Terraform Visualizer"
  homepage "https://github.com/im2nguyen/rover"
  url "https://github.com/im2nguyen/rover/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "c49a840030f4f864c1b360f09a50917f9b4ffda08a1ba4834d1c1e3d5b9d152e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf0a8043de95076bb307200c101db95f8d4e42c8f0e5787fd8aa3ac7192dc3e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "952e3e398a48f0a4697af849f275f8f83c5cc10eef151793897d336074ecd8ba"
    sha256 cellar: :any_skip_relocation, monterey:       "56e5cd0a650757b2b408648b4be60ca14012bccdc811fc82c7de6d984307bded"
    sha256 cellar: :any_skip_relocation, big_sur:        "7feb2087d5615755e8f06745c2df7a74b8e51f200ee3aaa4da9393ef7bdd466d"
    sha256 cellar: :any_skip_relocation, catalina:       "31f7684561978d42340fe062750f8d8fbd30fd12fe6a6ffdba222e42d565ed7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ea128eb5d636d264f865e67b1a0f6618571df1636865e0eca01c9a1b764ef32"
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
