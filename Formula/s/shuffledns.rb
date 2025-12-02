class Shuffledns < Formula
  desc "Enumerate subdomains using active bruteforce & resolve subdomains with wildcards"
  homepage "https://github.com/projectdiscovery/shuffledns"
  url "https://github.com/projectdiscovery/shuffledns/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "32507e92a754fce3bad6c6445a4199c11be298c0994719a39711e0354bde318f"
  license "GPL-3.0-or-later"
  head "https://github.com/projectdiscovery/shuffledns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "b603af4991e0ab74445ec68e50e92e2908275ff1b542ecaf3e26e273d5098d57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fa3569e66c96377923452d14e75ca31cdbaa56b933e83990cbe14cff5294de31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e1612f9b88c47df30bb100d925fcca6e895af63ce28e4cab15d46690f1865cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47bc85e79674caa717eb81f2a25477b97818c9f0474ae750f982eeb29e168d32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1041cd41f8c3b6c33a84a3c9d1469900f9fb107006a292f4bf536aab5a162624"
    sha256 cellar: :any_skip_relocation, sonoma:         "21f1a219457544d652c1b6d3838083e76761ce2897f79e25733b98a08f7ec9b2"
    sha256 cellar: :any_skip_relocation, ventura:        "6965ff8e440d2d14b37fb9e8d06af4907996caf60f7e1e2ae112b070d81aacf5"
    sha256 cellar: :any_skip_relocation, monterey:       "f0a3cb15f0ed449872b08e8b200e1ce1489b7a3dcf4a75ab4863011d34d80e4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4e5baacbe7dffd3ff78ab2c29b3d3ca8a747b9dbe7483d0308afded73492ebec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "324ae3f2ba05183d904a13a1c9f1d5ec796082b85c7883b264cff1f081972573"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/shuffledns"
  end

  test do
    assert_match "resolver file doesn't exists", shell_output("#{bin}/shuffledns 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/shuffledns -version 2>&1")
  end
end
