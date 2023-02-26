class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.3.2/sbcl-2.3.2-source.tar.bz2"
  sha256 "44cc162cfa6332a9a88c7a121d19038828a4ba4f6bffb77ef1c7b17407cb1eaa"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5a3bf9085fd025b24861c32099c4d0f11f73f1aa6220217480372d5df807bcef"
    sha256 cellar: :any,                 arm64_monterey: "4786400226f656439789f01a78fb86e200a482635aaa6106fc9241b631066a94"
    sha256 cellar: :any,                 arm64_big_sur:  "48ce8c3914bba7caf2a3361155cf78e054397072f72d1b7d44c6e98529f29504"
    sha256 cellar: :any,                 ventura:        "0e445e9d19f21bcc31f1d065b3188193ea297d99ae4cc8a45a51e764431e7e2e"
    sha256 cellar: :any,                 monterey:       "c5347247d8f7593a4554e34988d96883cf6ed70f536860065399a315aa882d72"
    sha256 cellar: :any,                 big_sur:        "14f50a393395696448da1c66a11dccf56796a898d12d126f1450ec5894a57e55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "718d93e9848a4ce6197495cc9af86d78b79ae3344a8898a18df4e905ceeecd64"
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
