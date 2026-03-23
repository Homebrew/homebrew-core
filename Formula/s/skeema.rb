class Skeema < Formula
  desc "Declarative pure-SQL schema management for MySQL and MariaDB"
  homepage "https://www.skeema.io/"
  url "https://github.com/skeema/skeema/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "05d259e214d81908880b7d3b3c0b99cecc8674e8df4220474863c5003a9ac215"
  license "Apache-2.0"
  head "https://github.com/skeema/skeema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09e95c80f0ea94675863694669cfaf9afe84c4c12e783f4dadb10c84763649dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09e95c80f0ea94675863694669cfaf9afe84c4c12e783f4dadb10c84763649dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09e95c80f0ea94675863694669cfaf9afe84c4c12e783f4dadb10c84763649dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "45ba7f03929b542b272931c89bb008b0dae549292dd5213cb78686bc82e7b807"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18cff9e58173dcadb4f6466de695af0de6e35eb73896d7680619d3f0e5b2ed77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f81f006ded0059c9c04220b9d1ad0c2595e5b54470557bfa7b7ac37c936090a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "Option --host must be supplied on the command-line",
      shell_output("#{bin}/skeema init 2>&1", 78)

    assert_match "Unable to connect to localhost",
      shell_output("#{bin}/skeema init -h localhost -u root --password=test 2>&1", 2)

    assert_match version.to_s, shell_output("#{bin}/skeema --version")
  end
end
