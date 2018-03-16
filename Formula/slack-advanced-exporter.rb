require "language/go"

class SlackAdvancedExporter < Formula
  desc "Exports additional data from Slack"
  homepage "https://github.com/grundleborg/slack-advanced-exporter"
  url "https://github.com/grundleborg/slack-advanced-exporter/archive/v0.2.0.tar.gz"
  sha256 "7aaf68249512a8000ae969742aeaad77bea3997915e35187a0c45f7d69728fdc"

  depends_on "go" => :build

  go_resource "gopkg.in/urfave/cli.v1" do
    url "https://github.com/urfave/cli.git",
        :revision => "cfb38830724cc34fedffe9a2a29fb54fa9169cd1"
  end

  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath/"src/github.com/grundleborg/slack-advanced-exporter"
    bin_path.install Dir["{*,.git}"]

    Language::Go.stage_deps resources, buildpath/"src"

    cd bin_path do
      system "go", "build", "-o", bin / "slack-advanced-exporter", "."
    end
  end

  test do
    assert_match "Slack Advanced Exporter version 0.2.0", shell_output("#{bin}/slack-advanced-exporter -v 2>&1", 2)
  end
end
