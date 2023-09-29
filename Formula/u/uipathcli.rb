class Uipathcli < Formula
  desc "Command-line to simplify, script and automate API calls to UiPath services"
  homepage "https://github.com/UiPath/uipathcli"
  url "https://github.com/UiPath/uipathcli.git",
      tag:      "v1.0.87",
      revision: "17a981bebaa7095ff2b3afd3231223fceb69b8ed"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build"
    mv "uipathcli", "uipath"
    bin.install "uipath"

    mv "definitions", "uipath-definitions"
    etc.install "uipath-definitions"
  end

  def caveats
    <<~EOS
      You may want to add the following to your .bash_profile:
        export UIPATH_DEFINITIONS_PATH="#{etc}/uipath-definitions"

      You can enable autocompletion by running the following command:
        uipath autocomplete enable --shell "bash"

      You can run the interactive config command to finish setting up your CLI:
        uipath config

      For more information you can read the documentation: https://github.com/UiPath/uipathcli#readme
    EOS
  end

  test do
    ENV["UIPATH_DEFINITIONS_PATH"] = "#{etc}/uipath-definitions"
    system "#{bin}/uipath", "--help"
  end
end
