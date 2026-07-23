class StaticWebAppsCli < Formula
  desc "SWA CLI serves as a local development tool for Azure Static Web Apps"
  homepage "https://azure.github.io/static-web-apps-cli/"
  url "https://registry.npmjs.org/@azure/static-web-apps-cli/-/static-web-apps-cli-2.0.10.tgz"
  sha256 "940fd1eab6fabc622ca4851cacd9ab7cbda2d53dd91369ec492d16e141ea22b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ab77301ca70bd36a21b406479238457a88936bb603ee1fddd83d141ea04968b4"
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
