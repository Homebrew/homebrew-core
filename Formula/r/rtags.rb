class Rtags < Formula
  desc "Source code cross-referencer like ctags with a clang frontend"
  homepage "https://github.com/Andersbakken/rtags"
  url "https://github.com/Andersbakken/rtags/releases/download/v2.44/rtags-2.44.tar.bz2"
  sha256 "3db5b36216e0b0a98fa7ad1e03a29b2ca7c9d895d85dbe3b2760fcdc2f962db3"
  license "GPL-3.0-or-later"
  head "https://github.com/Andersbakken/rtags.git", branch: "master"

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
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "d5cbf12e8b49fea2e82bfe1d149fac6a4b8491cc88b134d5dfb364fbc4d116d8"
    sha256 cellar: :any, arm64_sequoia: "7fe06ee97d346edb41b7a3ee18d8d13efe5b54b4d8ae6e87e2983111eaa1e101"
    sha256 cellar: :any, arm64_sonoma:  "1a992b51b048b29d94fb10bb6a50e0a1cdf2a3761e959cba97880ab128312561"
    sha256 cellar: :any, sonoma:        "06375c067b9667b6f201e3ce67853ca432133747249a90b53049bdec0742d0ba"
    sha256               arm64_linux:   "b9b7c563f938a73fd2537389b0c93037d95221f6b4002e0832b0a8518a4429f5"
    sha256               x86_64_linux:  "6189640b1116d0a70c690175bf2c37bdae14eda7c9b42b0e97789d4e5d24d675"
  end

  depends_on "cmake" => :build
  depends_on "emacs"
  depends_on "llvm"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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

    rdm = spawn "#{bin}/rdm", "--exclude-filter=\"\"", "-L", "log", [:out, :err] => File::NULL
    begin
      sleep 5
      sleep 10 if OS.mac? && Hardware::CPU.intel?
      pipe_output("#{bin}/rc -c", "clang -c #{testpath}/src/foo.c", 0)
      sleep 5
      assert_match "foo.c:1:6", shell_output("#{bin}/rc -f #{testpath}/src/foo.c:5:3")
      system bin/"rc", "-q"
    ensure
      Process.kill "TERM", rdm
      Process.wait rdm
    end
  end
end
