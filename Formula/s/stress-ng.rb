class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.22.00.tar.gz"
  sha256 "4dab6440b81a05468c256e3540285d167f4b8b35f48788723f46fada3b7b71a9"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81f244de48718d0e5bc01319b3a94399274ea5ddddedd30a9bf937a4b9e55f84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc690f438cc5cf091d487e5fcc874da8a5526f589b5a5bd6242a81463da76224"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "facbc73b640bec0d6de6722657fcceb0b9ce32f8642bfbc806c3b2bc8b9088c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "21cd99c4bd6949156e6431fbd9dfff167d9912fabf2ca480e446f08073573a35"
    sha256 cellar: :any,                 arm64_linux:   "588df8735d01237e72fcc7496d19c8cb699bdda0c0f47550623353943c986da5"
    sha256 cellar: :any,                 x86_64_linux:  "ae058f8bac85f72c65de765a106a836ad5e5fe3e73f8c720f34eba23370e7a20"
  end

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "acl"
    depends_on "zlib-ng-compat"
  end

  def install
    # disable target_clones so no non-baseline (AVX-512) code lands in the bottle
    ENV.append_to_cflags "-DHAVE_BUILD_SMALL" if Hardware::CPU.intel?

    inreplace "Makefile" do |s|
      s.gsub! "/usr", prefix
      s.change_make_var! "BASHDIR", prefix/"etc/bash_completion.d"
    end
    system "make"
    system "make", "install"
    bash_completion.install "bash-completion/stress-ng"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end
