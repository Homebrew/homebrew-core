class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.6.1/sbcl-2.6.1-source.tar.bz2"
  sha256 "5f2cd5bb7d3e6d9149a59c05acd8429b3be1849211769e5a37451d001e196d7f"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8f90df0b31107a2100e80116b835a2bd0656d340cb57a39e06a07864837a8dbb"
    sha256 cellar: :any,                 arm64_sequoia: "a837d209bc783bfbe7f125e3cb547d6259e6697d33cf8c121e3ce1438f75cad0"
    sha256 cellar: :any,                 arm64_sonoma:  "9b336d1018dbb5189e83e150817640bbceddc08aca00d155717d365ec0dc01e7"
    sha256 cellar: :any,                 sonoma:        "8512b478b3055b9363ca8e17e668ef9ffe7d7de0f99e57100278fd09ac9c786f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea4174664ca491e2a326230d8498f180d80b3b827804f757b262c9def9291f9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d5354c04cb3801624254c5e1c8f823fffd5a35be63c71d84ac18c65a198cdfa"
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
    (lib/"sbcl/sbclrc").write <<~LISP
      (setf (logical-pathname-translations "SYS")
        '(("SYS:SRC;**;*.*.*" #p"#{pkgshare}/src/**/*.*")
          ("SYS:CONTRIB;**;*.*.*" #p"#{pkgshare}/contrib/**/*.*")))
    LISP
  end

  test do
    (testpath/"simple.sbcl").write <<~LISP
      (write-line (write-to-string (+ 2 2)))
    LISP
    output = shell_output("#{bin}/sbcl --script #{testpath}/simple.sbcl")
    assert_equal "4", output.strip
  end
end
