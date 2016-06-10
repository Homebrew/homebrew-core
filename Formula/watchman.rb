class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v4.5.0.tar.gz"
  sha256 "ef11ad11f3b79a09232a27d993331cc8b686fe06a8f0e7c777cb50cc198020f6"
  head "https://github.com/facebook/watchman.git"

  bottle do
    sha256 "b630babd018142fb1fb8874444595a26ee99b361ba559308cf5cfd0df1486e7c" => :el_capitan
    sha256 "bcd3b0f4ffaaebadd043fd928dd72aa6213d87b8af162e8853689200de6fc4c9" => :yosemite
    sha256 "74c19390f79a0ca19faa5290f1e494cda14390606bb891a43cf8957d0098a3dd" => :mavericks
  end

  devel do
    url "https://github.com/facebook/watchman/archive/v4.6.0-rc2.tar.gz"
    version "4.6.0-rc2"
    sha256 "2b8cae97615cfa83178fdf0cc1e320a6b4c9277b07217f2c642ae240cc39be19"
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
