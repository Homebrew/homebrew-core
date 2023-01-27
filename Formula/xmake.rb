class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.7.6/xmake-v2.7.6.tar.gz"
  sha256 "6ae8ba15d5e6d8ebd05c70fb35ae0ade49f2742185a2908b25589a54f39de62f"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05a9f474fb460a2f96565640f7c6008bed0607452717719ed3f2f9dc1431d190"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfc777f5664f712aa8317556f6a1ad4b932ea8ac7e27e9d9b5ecc5d875b9689b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd3f78323c73db6bafbe753be3117d8cf915fd834c2533a2aec6e75c965c89e9"
    sha256 cellar: :any_skip_relocation, ventura:        "95d25fd4234cd1273af00ddab7d43a70052142d76583e0be7fe2a10d0d4a90d8"
    sha256 cellar: :any_skip_relocation, monterey:       "24ab7d497a68e885f425d3510669559b213d8022ed4d46132abad1cb0265dcfb"
    sha256 cellar: :any_skip_relocation, big_sur:        "c50ee5cbbc73137f9f4267354ab9ecea521091a9a1ddd38522e5ade7d1953206"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8287500219faf376951c4028e569fdc576ec87f1f28e9a0758066415c4b6f4e5"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    ENV["XMAKE_ROOT"] = "y" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "./configure"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    ENV["XMAKE_ROOT"] = "y" if OS.linux? && (ENV["HOMEBREW_GITHUB_ACTIONS"])
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end
