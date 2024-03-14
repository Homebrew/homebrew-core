class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.56/vala-0.56.16.tar.xz"
  sha256 "05487b5600f5d2f09e66a753cccd8f39c1bff9f148aea1b7774d505b9c8bca9b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "fc9fa37446e64f80a7677c36044388a79051c33bcb412d988ddd03a017c9999a"
    sha256 arm64_ventura:  "198702f6303d7c9d5328baf365e1a3c4a081f95c3280093126b01e93618df457"
    sha256 arm64_monterey: "4bacf02fde57abe5547d47177b0e40277f499d69733a10f84e9da41813155be1"
    sha256 sonoma:         "a02e06944c96f824d3829558ae151838268f758c0bdda3326b1a0297c13fd869"
    sha256 ventura:        "ffa5e6110916952089a3f73aeb52d27ca0bbd5bc231b039656eaa40e786e8804"
    sha256 monterey:       "bd12be11504f0dc71a96a099ebc86ab0de78357ee9d08719bfe0644058416edd"
    sha256 x86_64_linux:   "a49de854769b3edd75a1a0034f024841024af5954ae8cb54f2d409c966f8c1fa"
  end

  depends_on "gobject-introspection" => :build
  depends_on "glib"
  depends_on "graphviz"
  depends_on "pkg-config"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libxslt" => :build # for xsltproc

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make" # Fails to compile as a single step
    system "make", "install"
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    test_string = "Hello Homebrew\n"
    path = testpath/"hello.vala"
    path.write <<~EOS
      void main () {
        print ("#{test_string}");
      }
    EOS
    valac_args = [
      # Build with debugging symbols.
      "-g",
      # Use Homebrew's default C compiler.
      "--cc=#{ENV.cc}",
      # Save generated C source code.
      "--save-temps",
      # Vala source code path.
      path.to_s,
    ]
    system "#{bin}/valac", *valac_args
    assert_predicate testpath/"hello.c", :exist?

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
