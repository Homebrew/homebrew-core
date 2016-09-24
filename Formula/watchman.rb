class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v4.7.0.tar.gz"
  sha256 "77c7174c59d6be5e17382e414db4907a298ca187747c7fcb2ceb44da3962c6bf"
  head "https://github.com/facebook/watchman.git"

  bottle do
    cellar :any
    sha256 "370bf84f5a349db3ecd3e72c156b95a90bddf73029c062094a848dae123e3ada" => :sierra
    sha256 "543ee937e060a61028041ce3f8ea490602fab29b1427bed40152d47e7baa523c" => :el_capitan
    sha256 "c9ab24b2585ec3cce5641e4a31610916dd5e1a101a0c0e7695516ff32b4e5e9d" => :yosemite
    sha256 "ee4ec6d737f55204f2b33a3701c494b66353550532a0ec600ee81668be8d6c54" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pcre"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-pcre",
                          # we'll do the homebrew specific python
                          # installation below
                          "--without-python",
                          "--enable-statedir=#{var}/run/watchman"
    system "make"
    system "make", "install"

    # Homebrew specific python application installation
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    cd "python" do
      system "python", *Language::Python.setup_install_args(libexec)
    end
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def post_install
    (var/"run/watchman").mkpath
    chmod 042777, var/"run/watchman"
  end

  test do
    assert_equal /(\d+\.\d+\.\d+)/.match(version)[0], shell_output("#{bin}/watchman -v").chomp
  end
end
