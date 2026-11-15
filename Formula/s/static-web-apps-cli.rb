class StaticWebAppsCli < Formula
  desc "SWA CLI serves as a local development tool for Azure Static Web Apps"
  homepage "https://azure.github.io/static-web-apps-cli/"
  url "https://registry.npmjs.org/@azure/static-web-apps-cli/-/static-web-apps-cli-2.1.0.tgz"
  sha256 "e1df5e6c83c7e9e23f74dbb2eb21080b01ec012fa7f321e44f29c5c4601a89c7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7414bd2516cd7672dd514d234874d56b8b03ac600b93c61e9e27e4d4909fab51"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/swa --version")

    system bin/"swa", "init", "--yes"
    assert_path_exists testpath/"swa-cli.config.json"

    token = shell_output("#{bin}/swa deploy --print-token -dr")
    assert_match "undefined", token
    assert_match "Deploying to environment: preview", token
    assert_match testpath.to_s, token
  end
end
