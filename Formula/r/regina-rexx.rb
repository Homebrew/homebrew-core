class ReginaRexx < Formula
  desc "Interpreter for Rexx"
  homepage "https://regina-rexx.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/regina-rexx/regina-rexx/3.9.6/regina-rexx-3.9.6.tar.gz"
  sha256 "ed98c7a7f1d5a4148b02fef1b16aee4a6a6d8658d01a80cf5c503015ef01afa5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia:  "79accedd5ee5e49f1a5f480dcc126702d604ba5c018a4c15502ff31a772121ff"
    sha256 arm64_sonoma:   "c66acc278833ab29504dea15de9e0982fe5e138e2d10452429721a2e69925c71"
    sha256 arm64_ventura:  "0f6d600a409156119c45453232d6d020023cb9aee2c063bfa30841d835e72521"
    sha256 arm64_monterey: "cf0cfee8e56e38403ac472aed56cde78850121b7b5adbd52ccc27387d763af5a"
    sha256 sonoma:         "96b18ac7771715b1655532e50a80d53652270297ba98f543818392a9f55fe850"
    sha256 ventura:        "dbace070503339b00048f858b5e84dda450c15954d1e58b7141a8ea47eec0f39"
    sha256 monterey:       "2a03b38f8aadc69740e1fcf98425fa4e978f9549f65b7cbab31c64bca431be9b"
    sha256 x86_64_linux:   "3b18e755fb8d0f75a5782a91ca4f36dd6be9cba68e24575af20dc7c271d99381"
  end

  uses_from_macos "libxcrypt"

  def install
    ENV.deparallelize # No core usage for you, otherwise race condition = missing files.
    system "./configure", *std_configure_args,
                          "--with-addon-dir=#{HOMEBREW_PREFIX}/lib/regina-rexx/addons",
                          "--with-brew-addon-dir=#{lib}/regina-rexx/addons"
    system "make"

    install_targets = OS.mac? ? ["installbase", "installbrewlib"] : ["install"]
    system "make", *install_targets
  end

  test do
    (testpath/"test").write <<~EOS
      #!#{bin}/regina
      Parse Version ver
      Say ver
    EOS
    chmod 0755, testpath/"test"
    assert_match version.to_s, shell_output(testpath/"test")
  end
end
