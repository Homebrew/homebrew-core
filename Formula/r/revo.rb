class Revo < Formula
  desc "Dynamic language for the joy of programming"
  homepage "https://revo.lung.fyi"
  license "MIT"

  stable do
    url "https://github.com/if-not-nil/revo/archive/refs/tags/0.1.2.tar.gz"
    sha256 "cd1295272babdf1fe8ee1fc24fa94ee7077f5bbd41e84ee162679214c41ec614"

    # TODO: switch to Zig 0.17 in the next release
    depends_on "zig@0.16" => :build
  end

  head do
    url "https://github.com/if-not-nil/revo.git", branch: "main"

    depends_on "zig" => :build
  end

  deny_network_access!

  def fetch
    system "zig", "build", "--fetch=all"
  end

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    (testpath/"test.rv").write <<~'REVO'
      const x = 42

      print("My constant in #{x}")
    REVO

    assert_match "My constant in 42", shell_output("#{bin}/revo test.rv")
  end
end
