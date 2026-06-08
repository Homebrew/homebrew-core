class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.6.5/sbcl-2.6.5-source.tar.bz2"
  sha256 "91ec75f647252ed6e6aeae9b1a13f47c7c6cfd9b68488dc69f1a6fea5accb440"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  compatibility_version 4
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "d83ae56bfe2a99778119834125191a6e44a76a6565f1c1d0be67fd6523c060c2"
    sha256 cellar: :any, arm64_sequoia: "38c848a6886690ee54a5441f77a6b3580f881f3d0b02bb16b48ffca77011b773"
    sha256 cellar: :any, arm64_sonoma:  "88f7b071b70fcd7af0818b015d75a5a30bc5726bfc912436ec10687c7f5faa59"
    sha256 cellar: :any, sonoma:        "20cb98356f17afb98d69c9ea1f42cfc4e03a493c4c847ae42005d848944c0ead"
    sha256 cellar: :any, arm64_linux:   "da6cb66f75e79943d27fa45fc55ff97aa65ee18362bf28b2c753049315b684d1"
    sha256 cellar: :any, x86_64_linux:  "d92e42e8935af3d40c539195ca034a05fbf37f44e41332451809c29aabaa53a9"
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
