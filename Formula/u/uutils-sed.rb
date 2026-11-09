class UutilsSed < Formula
  desc "Cross-platform Rust rewrite of GNU sed"
  homepage "https://uutils.org/sed/"
  url "https://github.com/uutils/sed/archive/refs/tags/0.3.0.tar.gz"
  sha256 "d879d292ff93f4f769f299fb183be69d3ea6bcedeb2a698d944595ebc3a8dd6c"
  license "MIT"
  head "https://github.com/uutils/sed.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    uubin = libexec/"uubin"

    system "cargo", "install", *std_cargo_args

    mkdir_p uubin
    Dir.children(bin).each do |cmd_name|
      uucmd_name = "uu-#{cmd_name}"
      mv bin/cmd_name, bin/uucmd_name
      uubin.install_symlink bin/uucmd_name => cmd_name
    end
  end

  def caveats
    <<~EOS
      Commands have been installed with the prefix "uu-".
      If you need to use these commands with their normal names, you
      can add a "uubin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}/uubin:$PATH"
    EOS
  end

  test do
    test_file = testpath/"test.txt"

    [bin/"uu-sed", libexec/"uubin/sed"].each do |cmd|
      test_file.write "Hello world!"
      system cmd, "-i", "s/world/World/g", "test.txt"
      assert_match "Hello World!", test_file.read
      rm test_file
    end
  end
end
