class StylishHaskell < Formula
  desc "Haskell code prettifier"
  homepage "https://github.com/haskell/stylish-haskell"
  url "https://github.com/haskell/stylish-haskell/archive/refs/tags/v0.14.6.0.tar.gz"
  sha256 "0c0f34271670c23cc4feec7da04487a169a3cd0fde995721503bb5379755b91a"
  license "BSD-3-Clause"
  head "https://github.com/haskell/stylish-haskell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "79589b4fe79b3946c7ac4650c029918b550869a01c7321842f5144f73afebf7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b021fdde87163cb6d75aab1c0cecd36484309e51823a9aad8951f628d82adb98"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0d2da6f59fc1a29e6a6545ae586331ca53e6418ffde85a96dc9e94e230f9ec6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92a69d8d9bdb376f73cfc90bec09b4d009010496d8eff8ba0ddc8c88db1014f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ad14d6df5d417f7ca72f754950b9653c8f84f9cfc1eaf534bd769935dc328f5"
    sha256 cellar: :any_skip_relocation, ventura:        "d88200ce18cf61fdced6097fe0cf88df5bcff75a5bf557e19ce83a9cfba64e0c"
    sha256 cellar: :any_skip_relocation, monterey:       "d7d36832ae99a50e67b3051d648826ee404bc4334d57e61b602ebb10d727c12b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1742bbfd81d2f9ae39b6f52a08144b81d02f1be07c57ccbfc741f66c10c47219"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"test.hs").write <<~EOS
      {-# LANGUAGE ViewPatterns, TemplateHaskell #-}
      {-# LANGUAGE GeneralizedNewtypeDeriving,
                  ViewPatterns,
          ScopedTypeVariables #-}

      module Bad where

      import Control.Applicative ((<$>))
      import System.Directory (doesFileExist)

      import qualified Data.Map as M
      import      Data.Map    ((!), keys, Map)
    EOS
    expected = <<~EOS
      {-# LANGUAGE GeneralizedNewtypeDeriving #-}
      {-# LANGUAGE ScopedTypeVariables        #-}
      {-# LANGUAGE TemplateHaskell            #-}

      module Bad where

      import           Control.Applicative ((<$>))
      import           System.Directory    (doesFileExist)

      import           Data.Map            (Map, keys, (!))
      import qualified Data.Map            as M
    EOS
    assert_equal expected, shell_output("#{bin}/stylish-haskell test.hs")
  end
end
