class Rdap < Formula
  desc "Command-line client for the Registration Data Access Protocol"
  homepage "https://www.openrdap.org"
  url "https://github.com/openrdap/rdap/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "06a330a9e7d87d89274a0bcedc5852b9f6a4df81baec438fdb6156f49068996d"
  license "MIT"
  head "https://github.com/openrdap/rdap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2b0cb4f88c751e154d5154f7aa902d886a280f0d4fc45618e7887ef810dd9fe4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f017c594a757f00c98b0b48306a8b3a3a438d312b16a77c3840553c2debcbef4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54ea5ea4262c179ff3ce0ec8899ef858a5999e9c9c0ddef471badf66e7c3f2be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bc124e0bb9533626c3cbb0b35c852b8c4d48ab59b1102a241a9365e755e9868"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4879a4f4501db20b71e6ad669aceafce95d952081d1fa7c6f1b8a75a7066a98"
    sha256 cellar: :any_skip_relocation, ventura:        "f9ed293d7e9c2cc430465f33e9e404e662912281764f65b7142f21409625dbec"
    sha256 cellar: :any_skip_relocation, monterey:       "70c44872af154a6ba84ba86294b9b3c6d51e95167739cfe706ddbd5bee4e3e5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d84e08854b7b1a1376035b1ddba94ffd6072e456f7cbe2f3a78b3bd40ed513f6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/rdap"
  end

  test do
    # check version
    assert_match "OpenRDAP v#{version}", shell_output("#{bin}/rdap --help 2>&1", 1)

    # no localhost rdap server
    assert_match "No RDAP servers found for", shell_output("#{bin}/rdap -t ip 127.0.0.1 2>&1", 1)

    # check github.com domain on rdap
    output = shell_output("#{bin}/rdap github.com")
    assert_match "Domain Name: GITHUB.COM", output
    assert_match "Nameserver:", output
  end
end
