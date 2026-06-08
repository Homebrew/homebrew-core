class ReginaRexx < Formula
  desc "Interpreter for Rexx"
  homepage "https://regina-rexx.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/regina-rexx/regina-rexx/3.9.7/regina-rexx-3.9.7.tar.gz"
  sha256 "f13701ebd542e74d0fc83b2a7876a812b07d21e43400275ed65b1ac860204bd4"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "d76bfed5b0028c56cafecba2170f782ed8931dd6407df7d000bd96d0efdf8e40"
    sha256 arm64_sequoia: "d46186cbae2e186143060856047562350893ed578530dc613bf6937d6256fd03"
    sha256 arm64_sonoma:  "bab4ff512b66e827e7da2dcf394cdf82aba419cc239080d869f57d99a2cfa2d5"
    sha256 sonoma:        "8145e5d4412439e1e009aa1f4ed9c38f3a09f98a52d95c2ec1a12f3d44615a06"
    sha256 arm64_linux:   "7af7c2860e82d3491fd3c16780357d93cf5e079faa31818422788639409ef536"
    sha256 x86_64_linux:  "bfd12c2f8bcc5e7a606df315404dd46fe556613c395bb87f0971c7bf7f85e868"
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
