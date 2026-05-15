class Wiki < Formula
  desc "Fetch summaries from MediaWiki wikis, like Wikipedia"
  homepage "https://github.com/walle/wiki"
  url "https://github.com/walle/wiki/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "529c6a58b3b5c5eb3faab07f2bf752155868b912e4f753e432d14040ff4f4262"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "599b6bc13279811f7950b1ac2a170292f250aef8b5d3917254163b516984278c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "599b6bc13279811f7950b1ac2a170292f250aef8b5d3917254163b516984278c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "599b6bc13279811f7950b1ac2a170292f250aef8b5d3917254163b516984278c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1fb505814ff97dc285f4c587344383290a2ea9a17865cdb97f0a62b3d1d89ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eca2c5fde9cc0c01fdab8accc0a333b4ba6e713f8b1226b8b5e10dde71220d72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9ab56294402a19bbdd03974ad3f685720da32d1c8676411b771941343fb5089"
  end

  deprecate! date: "2025-09-12", because: :unmaintained

  depends_on "go" => :build

  # Add a User-Agent header to requests to avoid an error
  patch :DATA

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/wiki"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wiki --version")

    assert_match "Read more: https://en.wikipedia.org/wiki/Go", shell_output("#{bin}/wiki golang")
  end
end

__END__
diff --git a/request.go b/request.go
index a365760..be8e9cb 100644
--- a/request.go
+++ b/request.go
@@ -54,7 +54,13 @@ func (r *Request) Execute(noCheckCert bool) (*Response, error) {
 		client = &http.Client{Transport: tr}
 	}
 
-	response, err := client.Get(r.String())
+	req, err := http.NewRequest("GET", r.String(), nil)
+	if err != nil {
+		return nil, err
+	}
+	req.Header.Set("User-Agent", "wiki-cli/1.4.1")
+
+	response, err := client.Do(req)
 	if err != nil {
 		return nil, err
 	}
