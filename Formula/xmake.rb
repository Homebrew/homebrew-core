class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.6.9/xmake-v2.6.9.tar.gz"
  sha256 "68f2e7ef85db2841c707bb909ae4a5d058e8c1e4837c2a95b0bfefd56600ca83"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d926526bb094a6a95f4c44cf23d8f1c9b210c79382b890bd44cef3b9c13d7cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c67565964556e1c9cfd2ed694ebf2646898f374f7a8da85deee7b56ca6ad7192"
    sha256 cellar: :any_skip_relocation, monterey:       "f1a9ac4a6104e95e1bd170cd33592673e0735877e0c3b0df17a9c798dc6e42d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa736a785bd5732b736d5e8bce3f2fb1058a99e0c55f7fdc19a8786e320a6ed5"
    sha256 cellar: :any_skip_relocation, catalina:       "65994c96ab2d89efca366550d479e894b77a99047c9afc0f29ca7650b60c3c2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7280d87dad7d5d083796e07610bf63ee86ac3fca9348f6d30327b283ee330293"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    ENV["XMAKE_ROOT"] = "y" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "make"
    system "make", "install", "prefix=#{prefix}"
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
