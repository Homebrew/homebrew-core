class TerraformRover < Formula
  desc "Terraform Visualizer"
  homepage "https://github.com/im2nguyen/rover"
  url "https://github.com/im2nguyen/rover/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "491709df11c70c9756e55f4cd203321bf1c6b92793b8db91073012a1f13b42e5"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0c8bae1c6ef570dad674bd7984d2f20ee36b55d92c2c73e9ea6fb96d1fbad622"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "190f1c6618d6c0ce1b895f0337e312d2db36c4c0e9020b97384b6ac7140eaae3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1818e26e098b7c82f51fae7441e753503c7e4a75276d251febef3d4857f0c6d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "565e31665caca943d71cc52d6c7b59b688fa54f02455091f7c6770bae0742a4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a438136c2b7532ebda2f4d03b932e447b15c9f30ca81eabac463578ed4b72ad9"
    sha256 cellar: :any_skip_relocation, sonoma:         "d54c14df4cf66eb0b4fd5fae9a343a819e26a592d4dca3e8a28ff273e0a9d67d"
    sha256 cellar: :any_skip_relocation, ventura:        "4931a68ebe6dae34d3d55d53dacfadcb42467f09dd4716459dbb4ab37dc74984"
    sha256 cellar: :any_skip_relocation, monterey:       "a68c002a32b05deaa61a950e2fbf62ea55ba2cdd5836314e0014c9f8cea09e10"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5e72acca059507deef119a07073f60d8a4183fdb59393412fd2353b4eb6d41d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b078227fb4f38d09892b8ff73db1cb786940ef8dbb850e2f75c7c79d4688c882"
  end

  # https://github.com/im2nguyen/rover/issues/125
  # https://github.com/im2nguyen/rover/issues/133
  deprecate! date: "2024-02-22", because: "depends on soon-to-be-deprecated terraform"
  disable! date: "2025-02-24", because: "depends on terraform"

  depends_on "go" => :build
  depends_on "node"
  depends_on "terraform"

  # build patch for building with node 20 and go 1.21.0
  # fix `Error: error:0308010C:digital envelope routines::unsupported` error
  # upstream patch PR, https://github.com/im2nguyen/rover/pull/128
  patch do
    url "https://github.com/im2nguyen/rover/commit/8f5c9ca2ca6294c6a0463199ace822335c780041.patch?full_index=1"
    sha256 "c13464fe2de234ab670e58cd9f8999d23b088260927797708ce00bd5a11ce821"
  end
  patch do
    url "https://github.com/im2nguyen/rover/commit/989802276f74c57406a6b23a8d7ccc470fcdc975.patch?full_index=1"
    sha256 "3550755a11358385000f1a6af96a305c3f49690949d079d8e4fd59b8d17a06f5"
  end

  def install
    cd "ui" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"main.tf").write <<~HCL
      output "hello_world" {
        value = "Hello, World!"
      }
    HCL
    system bin/"terraform-rover", "-standalone", "-tfPath", Formula["terraform"].bin/"terraform"
    assert_path_exists testpath/"rover.zip"

    assert_match version.to_s, shell_output("#{bin}/terraform-rover --version")
  end
end
