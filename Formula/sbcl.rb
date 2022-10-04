class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  # Remove `stable` block when patch is no longer needed.
  stable do
    url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.2.9/sbcl-2.2.9-source.tar.bz2"
    sha256 "7ebebd6d2023fff7077b0372fa1171f880529bdec6104f20983297c2feb7c172"

    # Fix Catalina build. Remove in next version.
    patch do
      url "https://github.com/sbcl/sbcl/commit/171cef936ad8c68a5892d59b758930c99fcea1cc.patch?full_index=1"
      sha256 "f86e289d002c76065a72d643ac786646e778080d77ce543d832d683e0d30bea8"
    end
  end

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "89e604fdf546b9070682a72f99d6e8d27217442c21398aac6949e99e0d479eb7"
    sha256 cellar: :any,                 arm64_big_sur:  "47d0d235fa09665ebf2bead963472e1618fe1760d8b17330f97c02d07ee39411"
    sha256 cellar: :any,                 monterey:       "24b35feacd60ea1ab6884df95728601e9c65410fec6004a988aa481ccf9a3108"
    sha256 cellar: :any,                 big_sur:        "e0397aa657cd7a48c58821d36592945f3067690b11fc00cff6aba9c4e69603e8"
    sha256 cellar: :any,                 catalina:       "071a547ad2d1d4421943228898071268f4f1d1caf6c87967ed9d2c586a5f14bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15ccf8f748989caab179478b704d14451c06dd3e2c0ef4df6ac5e2b52fa24ec3"
  end

  depends_on "ecl" => :build
  depends_on "zstd"

  def install
    # Remove non-ASCII values from environment as they cause build failures
    # More information: https://bugs.gentoo.org/show_bug.cgi?id=174702
    ENV.delete_if do |_, value|
      ascii_val = value.dup
      ascii_val.force_encoding("ASCII-8BIT") if ascii_val.respond_to? :force_encoding
      ascii_val =~ /[\x80-\xff]/n
    end

    xc_cmdline = "ecl --norc"

    args = [
      "--prefix=#{prefix}",
      "--xc-host=#{xc_cmdline}",
      "--with-sb-core-compression",
      "--with-sb-ldb",
      "--with-sb-thread",
    ]

    ENV["SBCL_MACOSX_VERSION_MIN"] = MacOS.version
    system "./make.sh", *args

    ENV["INSTALL_ROOT"] = prefix
    system "sh", "install.sh"

    # Install sources
    bin.env_script_all_files libexec/"bin",
                             SBCL_SOURCE_ROOT: pkgshare/"src",
                             SBCL_HOME:        lib/"sbcl"
    pkgshare.install %w[contrib src]
    (lib/"sbcl/sbclrc").write <<~EOS
      (setf (logical-pathname-translations "SYS")
        '(("SYS:SRC;**;*.*.*" #p"#{pkgshare}/src/**/*.*")
          ("SYS:CONTRIB;**;*.*.*" #p"#{pkgshare}/contrib/**/*.*")))
    EOS
  end

  test do
    (testpath/"simple.sbcl").write <<~EOS
      (write-line (write-to-string (+ 2 2)))
    EOS
    output = shell_output("#{bin}/sbcl --script #{testpath}/simple.sbcl")
    assert_equal "4", output.strip
  end
end
