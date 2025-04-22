class StylishHaskell < Formula
  desc "Haskell code prettifier"
  homepage "https://github.com/haskell/stylish-haskell"
  url "https://github.com/haskell/stylish-haskell/archive/refs/tags/v0.15.1.0.tar.gz"
  sha256 "0187bb335205f6b5c9c78d3fc27deb59ce7122c7eb7429b88971d8cb25d7be51"
  license "BSD-3-Clause"
  head "https://github.com/haskell/stylish-haskell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8617c445f903d5a7e91963f407d839ea01e4ed7e33d48f96696ec2a0dd4a568c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3546de3bd2ec97bd2ce3cef71c838d682991cf156b01b5d9fecb97be186ead46"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "caa3a5292125407b6489eb7f121d45b2f10a41759362d552a54edef87c176fb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "05d8ff7fa92c64e886dd67007d151292701f7558106143dcd821d1469a2ce74a"
    sha256 cellar: :any_skip_relocation, ventura:       "af74b98d36e9806edf65cc30fb9dacbaa76cbadabb2ecbd5aa75039e9a1d5760"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce716b2eec6706796822c8c638969d9156534747a57f68a90e4d929692774bac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9386aab06b8ff3f6fa0d670681e2d7176f6250f5546281f4003265d365b9224"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"test.hs").write <<~HASKELL
      {-# LANGUAGE ViewPatterns, TemplateHaskell #-}
      {-# LANGUAGE GeneralizedNewtypeDeriving,
                  ViewPatterns,
          ScopedTypeVariables #-}

      module Bad where

      import Control.Applicative ((<$>))
      import System.Directory (doesFileExist)

      import qualified Data.Map as M
      import      Data.Map    ((!), keys, Map)
    HASKELL
    expected = <<~HASKELL
      {-# LANGUAGE GeneralizedNewtypeDeriving #-}
      {-# LANGUAGE ScopedTypeVariables        #-}
      {-# LANGUAGE TemplateHaskell            #-}

      module Bad where

      import           Control.Applicative ((<$>))
      import           System.Directory    (doesFileExist)

      import           Data.Map            (Map, keys, (!))
      import qualified Data.Map            as M
    HASKELL
    assert_equal expected, shell_output("#{bin}/stylish-haskell test.hs")
  end
end
