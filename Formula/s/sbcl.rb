class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.4.0/sbcl-2.4.0-source.tar.bz2"
  sha256 "83d8b74f08d2254c59b9790bc1f669e09099457b884720ececbf45f4b46d1776"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9141e306cab44c7345b6e08f35718856ea94fccac4cbef138f3f27104b9781ce"
    sha256 cellar: :any,                 arm64_ventura:  "1c53179c5d36187ff56b77a7824f3f2b0f31a4d90e8885826e6b08583b1fbfac"
    sha256 cellar: :any,                 arm64_monterey: "4247329dd8d9c12b0f14578b48bcd35f47ee2af39d6d5356327922c75894b78d"
    sha256 cellar: :any,                 sonoma:         "7845f98c6929acf932d4f265b01b9605d8378557d72b88f1ce220ef2b86652a4"
    sha256 cellar: :any,                 ventura:        "00c0c007592f3371b9d3b86f8451f1d174e9937524e284ddf2985d4310a7c227"
    sha256 cellar: :any,                 monterey:       "84598fec6a247e5c1d38c8c35808fbce4f2170f96a0a56bfc79b00d8d3d55ed5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9f035ea9d95766d4222de7799969f4f31bdd642ecb03bdfb56179e45ab53f1d"
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

    ENV["SBCL_MACOSX_VERSION_MIN"] = MacOS.version.to_s if OS.mac?
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
