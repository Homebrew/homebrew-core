class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.5.6/sbcl-2.5.6-source.tar.bz2"
  sha256 "6dd7cebff6d38f2e41baece14c4c56a32e968828aaa4171b8e840852c5b43f35"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0b19b77a0ea43870a22b78be5924bd121bedb276a1e97cb8eb0725d66ef26f52"
    sha256 cellar: :any,                 arm64_sonoma:  "3e30b1fd5db12bfcd9b7600645843165ec730855b6e31c276573246b103dca9f"
    sha256 cellar: :any,                 arm64_ventura: "5bef3c393f46aa91482c75c8b8a012c0d1a65b0e132b04808310cae0f80c7ed5"
    sha256 cellar: :any,                 sonoma:        "231846b45eae283d5df3201f5b65337fda927c7c57fc4700a6e2c65cc5700cc4"
    sha256 cellar: :any,                 ventura:       "5ece0e93eb8fbb81976e8b9fc5d9f73ad09c5cf7466baa6dde9cb46caa0f3b6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fec194d21dfbb6cb1aa4f8ada9e3861c789df854910a818d626c35093444d4fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac279fc16a9b480e72007abf563cda707db26a1abfb171eb4e9d09cee595a544"
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
