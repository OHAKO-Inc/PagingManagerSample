is_wip = github.pr_title.include? '[WIP]'
# is_assigned_reviewer = github.pr.requested_reviewers.length > 0
has_milestone = github.pr_json["milestone"] != nil
has_assignee = github.pr_json["assignee"] != nil

# -------------------------------
# messages
# -------------------------------

message "Hi, danger is ready. :construction_worker:"

if is_wip
markdown('# このPRは作業中です')
end


# -------------------------------
# common check
# -------------------------------

# マイルストーンのチェック
message("マイルストーンが未設定です") unless has_milestone

# 作業者のチェック
warn("作業者をアサインしましょう", sticky: false) unless has_assignee

# マージ先のチェック
warn("マージ先をdevelopに設定しましょう") if !github.branch_for_base == "develop"

# 行数チェック
warn("500行超えてます。分割できるとベターですね") if git.lines_of_code > 500

# WIPラベルのチェック
# warn("作業中でしたらWIPをつけましょう") if !is_wip && !is_assigned_reviewer
# warn("レビュー申請時はWIPを外しましょう") if is_wip && is_assigned_reviewer


# -------------------------------
# iOS development check
# -------------------------------

# App.xcodeproj/project.pbxproj の変更チェック
message ("`App.xcodeproj/project.pbxproj` が変更されています") if git.modified_files.include? "App.xcodeproj/project.pbxproj"

# Cartfile の変更チェック
message ("`Cartfile` が変更されています") if git.modified_files.include? "Cartfile"
message ("`Cartfile.resolved` が変更されています") if git.modified_files.include? "Cartfile.resolved"

# Podfile の変更チェック
message ("`Podfile` が変更されています") if git.modified_files.include? "Podfile"
message ("`Podfile.lock` が変更されています") if git.modified_files.include? "Podfile.lock"


# -------------------------------
# lgtm
# -------------------------------

# add lgtm pic
lgtm.check_lgtm
