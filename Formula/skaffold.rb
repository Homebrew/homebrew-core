class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleCloudPlatform/skaffold"
  url "https://github.com/GoogleCloudPlatform/skaffold.git",
      :tag => "v0.2.0",
      :revision => "eb0fd0223bb9ec640f1031bb8c9858ef22338e01"

  bottle do
    cellar :any_skip_relocation
    sha256 "25806ae7bcba82a06e7f4ff63a490d26f9d97dd46062a3b4511f326904bbb347" => :high_sierra
    sha256 "b3a55a722a08c9a98f01c77dd0f7c30d31423884e637288835a7ead93348ba5a" => :sierra
    sha256 "272fe7dda0b0298f0a3fd2445c76f7f3424080b86b7b344daae5da982af8b0c1" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/GoogleCloudPlatform/skaffold"
    dir.install buildpath.children - [buildpath/".brew_home"]
    cd dir do
      system "make"
      bin.install "out/skaffold"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/skaffold version --output {{.GitTreeState}}")
    assert_match "clean", output
  end
end
