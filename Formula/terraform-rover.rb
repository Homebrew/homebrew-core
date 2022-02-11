require "language/node"
class TerraformRover < Formula
  desc "Terraform Visualizer"
  homepage "https://github.com/im2nguyen/rover"
  url "https://github.com/im2nguyen/rover/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "8d880bdd2a4f0c6817c71d5da4e22c5ba5dafa2cec712101950fce530f20ea12"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de30fe4fcaf5c9389680870deef5810aeb4126b7ab4e3ad6da5768913006b02d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25c2b2f422a99bfaa7f528d046f66bc46461ed92aee11240e9ab48265d7996c8"
    sha256 cellar: :any_skip_relocation, monterey:       "f91c58bd82b597fd0aba039832677e7774b8d63e12952733dc583ec57aaecff0"
    sha256 cellar: :any_skip_relocation, big_sur:        "409ec855c86bd24d245df20e5e83d32301351afc9eb1f54add4eb014568c3be9"
    sha256 cellar: :any_skip_relocation, catalina:       "db3558eac800beb9a876e1c72689b50440e3f2743363a465e2d53fd8603a2273"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e89bed21e89d0a7485113d6d1507a34d6dcfbedaa0034583ead024eabc88cc68"
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
