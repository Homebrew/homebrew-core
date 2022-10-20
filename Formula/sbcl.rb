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
    sha256 cellar: :any,                 arm64_monterey: "08dc55aeb4d3c2f6caf90c32141277b00892e2d5ec7bdb6eb7a7b47b200341e4"
    sha256 cellar: :any,                 arm64_big_sur:  "0e4513fe179b6c87b350e3bf92b2130d78d555b2922e60a214b259fb368092f8"
    sha256 cellar: :any,                 monterey:       "a1b964e902d3874a9a753163703c06651a31862fe8bfacb38504f00f1ee5145b"
    sha256 cellar: :any,                 big_sur:        "cca24c9dd7a99df2ad5f340b1f12d48ef90eff5c3695806837cda266030ac6e8"
    sha256 cellar: :any,                 catalina:       "00fccb19530a9fe4f8fb6c2a2da26d82f5ba7aa586134387f934979064c53005"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22409d2c64da17c8407654487ed30435077861831b772cccdb83ba13e24c221f"
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
