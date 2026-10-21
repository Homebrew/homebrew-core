class Tinyframe < Formula
  desc "Minimalistic library for reading and writing the Frame Streams protocol"
  homepage "https://codeberg.org/DNS-OARC/tinyframe"
  url "https://www.dns-oarc.net/files/tinyframe/tinyframe-0.1.2.tar.gz"
  sha256 "181e18bf3e8067b5415f0179d1b35286bf1d379ba71bb89c8e6cc2a73c3cec8d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7c4a52ea7a2018bf86a62e6fe77450e7273ad3270332657fe723b5cd835c95b7"
    sha256 cellar: :any, arm64_tahoe:       "45c5916e69f53b359e526884988785d523e80fdbc62a8e9ff45b63839d68eb4f"
    sha256 cellar: :any, arm64_sequoia:     "10e9111fef322f83934a25fd824796e014340dfa3d530da1df69807bdde33e1c"
    sha256 cellar: :any, arm64_linux:       "3988479d468def85c0bce52961953f0b887b080a0331ebf91eca59e9932d3dd7"
    sha256 cellar: :any, x86_64_linux:      "8b2d8f36f095b68be6d7d6fa5c810d36a602af8ce8abb1f669e04842ae7f9954"
  end

  depends_on "pkgconf" => :test

  patch do
    on_macos do
      url "https://codeberg.org/smillernl/tinyframe/commit/c425d6c35edd05e3313baa5e5c87ef3b6e787118.patch"
      sha256 "8db7615be41f35cd9232d2039454c56118d2f904cd1eef5443a8a3b21a8a4926"
    end
  end

  deny_network_access!

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <tinyframe/version.h>
      #include <stdio.h>

      int main(int argc, char *argv[]) {
        printf("Version %s", TINYFRAME_VERSION_STRING);
        return 0;
      }
    C
    flags = shell_output("pkgconf --cflags --libs libtinyframe").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    assert_match version.to_s, shell_output("./test")
  end
end
