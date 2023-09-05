class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.3.8/sbcl-2.3.8-source.tar.bz2"
  sha256 "421571b2ac916e58be8ebcea5ef4abf8d7902863db6a1d0a5efa9500adca0d29"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f71ab0070669ec7057965001de151af70f4de90dcce77fda45a53c65245736b4"
    sha256 cellar: :any,                 arm64_monterey: "e8cc4c4be9b38f1314dded244f16ab3c9e93852a64643425be1c3cf9bf21ec4d"
    sha256 cellar: :any,                 arm64_big_sur:  "4df5348e2e46b75e1623f213faf6a0f0e64dd54a2e9bed7273f2c6a85ccb0a53"
    sha256 cellar: :any,                 ventura:        "9e16c416ab4b39b1d39964353df1e433fd80bf651bd2d87de3df30a61fa4059d"
    sha256 cellar: :any,                 monterey:       "1912f663a469f17cd13a0995e3c972d78116ba0bf5c3436ceb03cfedffde817e"
    sha256 cellar: :any,                 big_sur:        "ce988d40dff9bfb8768579ba05ad03bdfe1bbcd6e50d2fd28688810221497e48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04a31f6beb337dabd0a5ac075299bb82ef257a6940c519b767049108b1b4b198"
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

    ENV["SBCL_MACOSX_VERSION_MIN"] = MacOS.version.to_s
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
