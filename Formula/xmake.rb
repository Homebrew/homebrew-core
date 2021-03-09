class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.5.2/xmake-v2.5.2.tar.gz"
  sha256 "682c2908b80da7703d6b0213589274d41f76d2f3bc8bfe2eac5c5f625f1109b9"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "51f894c03cf74688b112286226e20c58f39f88642e1a81e95f2ffcf91d81e6d7"
    sha256 cellar: :any_skip_relocation, big_sur:       "09fc78ecc21694812befde77f5e2ad31f4fbf85e4c3326632f765921689b19ad"
    sha256 cellar: :any_skip_relocation, catalina:      "6530dd75e8041e2fb82c3d34de0dd87ad9eab622511633a5e82fd8f3169efe27"
    sha256 cellar: :any_skip_relocation, mojave:        "c1179ceea5ad3c3c9c803c1a58c3afa40d4a236f3ef65997e32df437eaed241f"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    on_linux do
      ENV["XMAKE_ROOT"] = "y" if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    on_linux do
      ENV["XMAKE_ROOT"] = "y" if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end
