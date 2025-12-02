class Rtags < Formula
  desc "Source code cross-referencer like ctags with a clang frontend"
  homepage "https://github.com/Andersbakken/rtags"
  license "GPL-3.0-or-later"
  head "https://github.com/Andersbakken/rtags.git", branch: "master"

  stable do
    url "https://github.com/Andersbakken/rtags.git",
        tag:      "v2.41",
        revision: "39339388256df662d0084b4a094d03e52748f9e8"

    # fix lisp files, remove on release 2.42
    patch do
      url "https://github.com/Andersbakken/rtags/commit/63f18acb21e664fd92fbc19465f0b5df085b5e93.patch?full_index=1"
      sha256 "3229b2598211b2014a93a2d1e906cccf05b6a8a708234cc54f21803e6e31ef2a"
    end
  end

  # The `strategy` code below can be removed if/when this software exceeds
  # version 3.23. Until then, it's used to omit a malformed tag that would
  # always be treated as newest.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :git do |tags, regex|
      malformed_tags = ["v3.23"].freeze
      tags.map do |tag|
        next if malformed_tags.include?(tag)

        tag[regex, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "48ad2bdaf1a5da69b0043dd8c7d4b9aa472c4a61556e16460cd973e2bf16a300"
    sha256 cellar: :any, arm64_sequoia: "8fd30b2507239fc7ff15cca941e00f105e8a6724b032a591b1b0d3812699d3cf"
    sha256 cellar: :any, arm64_sonoma:  "4bd18ea58c0d2161ea6b22209ae085719b21e4db751ab60f4a46911e770affd0"
    sha256 cellar: :any, arm64_ventura: "8a8fca81684ec7d9ddb05633c1f99b00f99f9222a6584bb494c52fa0ac0abe53"
    sha256 cellar: :any, sonoma:        "fce14066a6e4c0345b2a7e5ddf8e03be8f6d577b558d1c887a82afcfcb3a64e8"
    sha256 cellar: :any, ventura:       "719ad5a7d65ec34fbe8b28e3fe3c83c06a9a4e4d164da471f6658927d1a45b7c"
    sha256               arm64_linux:   "a044de5d959c2c7e6e1976922eb3488ab2d5a04069f2400c89b739fad39aad7c"
    sha256               x86_64_linux:  "606bea1ce1da5dfbddc609b1f5d80fb36b4edc7e5aa26351504b0bebb4edde74"
  end

  depends_on "cmake" => :build
  depends_on "emacs"
  depends_on "llvm"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Fix to add backward compatibility for CMake version 4
    # `master` and `v2.41` are differ too much and so patch is not working
    # PR ref: https://github.com/Andersbakken/rtags/pull/1443
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  service do
    run [opt_bin/"rdm", "--verbose", "--inactivity-timeout=300"]
    keep_alive true
    log_path var/"log/rtags.log"
    error_log_path var/"log/rtags.log"
  end

  test do
    mkpath testpath/"src"
    (testpath/"src/foo.c").write <<~C
      void zaphod() {
      }

      void beeblebrox() {
        zaphod();
      }
    C
    (testpath/"src/README").write <<~EOS
      42
    EOS

    rdm = fork do
      $stdout.reopen(File::NULL)
      $stderr.reopen(File::NULL)
      exec "#{bin}/rdm", "--exclude-filter=\"\"", "-L", "log"
    end

    begin
      sleep 5
      pipe_output("#{bin}/rc -c", "clang -c #{testpath}/src/foo.c", 0)
      sleep 5
      assert_match "foo.c:1:6", shell_output("#{bin}/rc -f #{testpath}/src/foo.c:5:3")
      system bin/"rc", "-q"
    ensure
      Process.kill 9, rdm
      Process.wait rdm
    end
  end
end
