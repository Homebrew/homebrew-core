class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta/archive/v1.1.1.tar.gz"
  sha256 "f2289274538124984bebb09b0968c2821368d8a80d60b9615e4f999f6751366d"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/volta-cli/volta.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56976a964b5691df00878ca4b5a9b0c2de474ca4856580fbb9f3d7b996079d40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cdcdd7fa16cd69f1f9311895455e545a03bd5d3d7e6c7ffb110e87e4fa4b744"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "950c8eda66c9409750320f9caf184985963fc7bee5e71118720c25435219f3dd"
    sha256 cellar: :any_skip_relocation, ventura:        "652e3f77444c142c0f3a91b6317ae3260d8e511c96fc2aff5a33003fb4cb3fcd"
    sha256 cellar: :any_skip_relocation, monterey:       "e195b2819ae7791255a8e9b40c7543a63ed0ec319715bc9689c604d8df4a4d4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a41e016f7b0feccc30ca7c5350483ddb9e13d7253a1610acffb417c81d23eef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4bbab4316b64e09c665e85239969e23e5ef9d02dadd784a72c168edb118cd61"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"volta", "completions")

    bin.each_child do |f|
      basename = f.basename
      next if basename.to_s == "volta-shim"

      (libexec/"bin").install f
      (bin/basename).write_env_script libexec/"bin"/basename, VOLTA_INSTALL_DIR: opt_prefix/"bin"
    end
  end

  test do
    system bin/"volta", "install", "node@19.0.1"
    node = shell_output("#{bin}/volta which node").chomp
    assert_match "19.0.1", shell_output("#{node} --version")
    path = testpath/"test.js"
    path.write "console.log('hello');"
    output = shell_output("#{testpath}/.volta/bin/node #{path}").strip
    assert_equal "hello", output
  end
end
