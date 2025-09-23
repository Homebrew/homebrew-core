class ReginaRexx < Formula
  desc "Interpreter for Rexx"
  homepage "https://regina-rexx.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/regina-rexx/regina-rexx/3.9.7/regina-rexx-3.9.7.tar.gz"
  sha256 "27f47cf54f67ca0df04603cce6567bc8f4682f605cfafec2d6de9d1ba96ac429"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia: "d513d8b3dd19132b2b9f10b29ee3c7e7bebb9f1c970fdbe56e52ef061b25b4d6"
    sha256 arm64_sonoma:  "f6305fc97baa0dbf21a313a8e02864d41b745c8c6f0cdb4a74d51e4f1e603f4e"
    sha256 arm64_ventura: "e803318a602b95ecbc33d9275d1790702ebb7461595eee0c9e2cee36521c8696"
    sha256 sonoma:        "9557066ae878d7582c732334bedd607ff987b668db841b27f0e32c9855153d46"
    sha256 ventura:       "07b0fbb0fe1bbefda3db096cabf9e2db7b66cf59b57222520eb91e61972b590f"
    sha256 arm64_linux:   "1df3d2120fdc1f7c016aaa5001ffbbbb288cfde30d72e8ee3c25bcce5de70e9e"
    sha256 x86_64_linux:  "808eeafe4cb1da835f4374f9d316219b8e9dcef1c9d725b7fe446961e98403ca"
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
