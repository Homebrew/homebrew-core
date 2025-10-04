class Rsql < Formula
  desc "CLI for relational databases and common data file formats"
  homepage "https://github.com/theseus-rs/rsql"
  url "https://github.com/theseus-rs/rsql/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "a6bf445998062dbb1a840895d42783ed947e42265422aba2bbdb8a669d2177d6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/theseus-rs/rsql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a936612adb0d6ea4764621131bf0604a23549355bc64f8f578344dd475505693"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b31ac7cc12a1f3a71885c4d0c53b023ea7d7d2a9709128e2ae712253937b6ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84a95550759893530a734322482d93f9e6456494e56706d9f93d23bfdcf6715a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c44f42187d6962c11a4a30194753555258ef609fb23dd972adef96354b0ecbc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f1ac82644cfa85718929241a5061bfc4f58232102a689b8a526cafb7a7e71fc"
    sha256 cellar: :any_skip_relocation, ventura:       "d6e10c5392373900a7bb9635cb5bddb140908d4d8937cb0a5ff01c7af36a89bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfa5d0128b0e49f2eb21e60348fd68cb7946b5e036d6802a03cbb62ff09ad3e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e8fe12b46214d9dea30d9cfb74696447421c3907759862628d83035eb5e7599"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "rsql_cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rsql --version")

    # Create a sample CSV file
    (testpath/"data.csv").write <<~CSV
      name,age
      Alice,30
      Bob,25
      Charlie,35
    CSV

    query = "SELECT * FROM data WHERE age > 30"
    assert_match "Charlie", shell_output("#{bin}/rsql --url 'csv://#{testpath}/data.csv' -- '#{query}'")
  end
end
