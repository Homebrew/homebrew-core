class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "e1915e192c78e53679995b042d152b6469ce43c785d104b8b15b36e63797b24e"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    manifest_sha256 "c874ec8583be41c9d2ac4e01ffb107fad2f6ffe89a19d8195bb7916c490d2331"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f698302309faa8641945b6e23efaa1334fbde6eb7ef2f6a79fa7d9b60f38b457"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f698302309faa8641945b6e23efaa1334fbde6eb7ef2f6a79fa7d9b60f38b457"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f698302309faa8641945b6e23efaa1334fbde6eb7ef2f6a79fa7d9b60f38b457"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "89845c53330afe28a84bcedabee415f943d8df0ebbe030cafe0960b93c699c35"
    sha256 cellar: :any,                 x86_64_linux:      "9eb6ef9d1faaea6cc505f12368aba026725af74b3f5a239d76caf1722fef5984"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
