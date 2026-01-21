class TrzszSsh < Formula
  desc "Alternative ssh client with additional features to meet your needs"
  homepage "https://trzsz.github.io/ssh"
  url "https://github.com/trzsz/trzsz-ssh/archive/refs/tags/v0.1.24.tar.gz"
  sha256 "8c7ef4ace4c7aed564f447f3f91142367f782eef87b58a95f587480ca1ae08ba"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5ed283aba0b804c2cb5c97e23b6129e0dbba74a5d531d81914679349e142265"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5ed283aba0b804c2cb5c97e23b6129e0dbba74a5d531d81914679349e142265"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5ed283aba0b804c2cb5c97e23b6129e0dbba74a5d531d81914679349e142265"
    sha256 cellar: :any_skip_relocation, sonoma:        "40a483218088b4650b3daccd27900b30c8e5476bd4ff48dc817f9fb9e39c6773"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c7ff339a7ea7d6883cbf8beb71b879b4e5d0121e7ebae8f1d2c5a4b7c5de5d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa6aa165501893dcd974e973f0e8c702dbd8d7e1ec665ff7277fa5eeb39d7317"
  end

  depends_on "go" => :build

  conflicts_with "tssh", because: "both install `tssh` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"tssh"), "./cmd/tssh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tssh -v")

    assert_match "invalid option", shell_output("#{bin}/tssh -o abc 2>&1", 11)
    assert_match "invalid bind specification", shell_output("#{bin}/tssh -D xyz 2>&1", 11)
    assert_match "invalid forwarding specification", shell_output("#{bin}/tssh -L 123 2>&1", 11)
  end
end
