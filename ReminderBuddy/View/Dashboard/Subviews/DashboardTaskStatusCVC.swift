import UIKit
import Charts

class DashboardTaskStatusCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private class TitleStack: UIView  {
        
        private let section: TaskManager.TaskType
        
        init(section: TaskManager.TaskType) {
            self.section = section
            super.init(frame: .zero)
            self.translatesAutoresizingMaskIntoConstraints = false
            addSubview(iconView)
            addSubview(titleLabel)
            NSLayoutConstraint.activate([
                iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
                titleLabel.topAnchor.constraint(equalTo: topAnchor),
                titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 6),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                iconView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
            ])
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .natural
            label.numberOfLines = 1
            label.textColor = Asset.ColorAssets.primaryColor1.color
            label.font = .appfont(font: .medium, size: 16)
            label.text = "\(section.rawValue) \(TaskManager.shared.getTasks(for: section).count)"
            label.setContentCompressionResistancePriority(.required, for: .horizontal)
            return label
        }()
        
        private lazy var iconView: UIView = {
            let iconView = UIView()
            iconView.translatesAutoresizingMaskIntoConstraints = false
            iconView.heightAnchor.constraint(equalToConstant: 12).isActive = true
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor, multiplier: 1).isActive = true
            iconView.layer.cornerRadius = 6
            switch section {
            case .completed:
                iconView.backgroundColor = .systemGreen
            case .inProgress:
                iconView.backgroundColor = .systemYellow
            case .created:
                iconView.backgroundColor = .systemBlue
            case .upcoming:
                iconView.backgroundColor = .orange
            case .dueTasks:
                iconView.backgroundColor = .systemRed
            case .all:
                break
            }
            return iconView
        }()

    }
    
    private lazy var verticalStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleStack1, titleStack2])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 6
        stackView.distribution = .fill
        return stackView
    }()
    
    
    
    private lazy var titleStack1: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 6
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    private lazy var titleStack2: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 6
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var sectionNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor =  Asset.ColorAssets.primaryColor1.color
        label.font = .appfont(font: .semiBold, size: 18)
        return label
    }()
    
    private lazy var pieChartView: PieChartView = {
        let view = PieChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.usePercentValuesEnabled = true
        view.drawSlicesUnderHoleEnabled = false
        view.holeRadiusPercent = 0.58
        view.transparentCircleRadiusPercent = 0.61
        view.chartDescription.enabled = false
        view.legend.enabled = false
        return view
    }()
    
    func setData(for section: TaskManager.TaskType, tasks: [UserTask]) {
        sectionNameLabel.text = sectionName(for: section, tasks: tasks)
        titleDetails(for: section, tasks: tasks)
        updateChart(section: section, tasks: tasks)
    }
    
    private func setupViews() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 16
        contentView.addSubview(sectionNameLabel)
        contentView.addSubview(verticalStack)
        contentView.addSubview(pieChartView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            sectionNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            sectionNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            sectionNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            pieChartView.topAnchor.constraint(equalTo: sectionNameLabel.bottomAnchor, constant: 0),
            pieChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            pieChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            pieChartView.heightAnchor.constraint(equalToConstant: 200),
            verticalStack.topAnchor.constraint(equalTo: pieChartView.bottomAnchor),
            verticalStack.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 16),
            verticalStack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            verticalStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            
        ])
    }
    
    private func sectionName(for section: TaskManager.TaskType, tasks: [UserTask]) -> String {
        switch section {
        case .all:
            return "\(section.rawValue) Tasks \(tasks.count)"
        default:
            return "\(section.rawValue) Tasks"
        }
    }
    
    private func titleDetails(for section: TaskManager.TaskType, tasks: [UserTask]) {
        titleStack1.subviews.forEach { view in
            view.removeFromSuperview()
        }
        titleStack2.subviews.forEach { view in
            view.removeFromSuperview()
        }
        let taskCount = TaskManager.shared.getTasks(for: section).count
        switch section {
        case .all:
            var count = 0
            TaskManager.TaskType.allCases.forEach { type in
                switch type {
                case .all:
                    break
                default:
                    if count < 2 {
                        titleStack1.addArrangedSubview(TitleStack(section: type))
                    } else {
                        titleStack2.addArrangedSubview(TitleStack(section: type))
                        titleStack2.isHidden = false
                    }
                    count += 1
                }
            }
        case .completed:
            fallthrough
        case .inProgress:
            fallthrough
        case .created:
            fallthrough
        case .upcoming:
            fallthrough
        case .dueTasks:
            titleStack1.addArrangedSubview(TitleStack(section: section))
            titleStack2.isHidden = true
        }

    }
    
    private func updateChart(section: TaskManager.TaskType, tasks: [UserTask]) {
        var taskCounts: [TaskEntry] = [] // Array to store task counts by type
        
        // Calculate counts for each task type
        switch section {
        case .completed, .inProgress, .created, .upcoming, .dueTasks:
            let taskCount = TaskManager.shared.getTasks(for: section).count
            taskCounts.append(TaskEntry(type: section.rawValue, count: taskCount, color: colorForTaskType(section)))
        case .all:
            TaskManager.TaskType.allCases.forEach { type in
                guard type != .all else { return }
                let taskCount = TaskManager.shared.getTasks(for: type).count
                taskCounts.append(TaskEntry(type: type.rawValue, count: taskCount, color: colorForTaskType(type)))
            }
        }
        
        // Prepare entries for pie chart
        var entries: [PieChartDataEntry] = []
        var colors: [UIColor] = []
        
        
        switch section {
        case .all:
            for task in taskCounts {
                let entry = PieChartDataEntry(value: Double(task.count), label: task.type)
                entries.append(entry)
                colors.append(task.color)
            }
        default:
            for task in taskCounts {
                let completedEntry = PieChartDataEntry(value: Double(task.count), label: task.type)
                let remainingEntry = PieChartDataEntry(value: Double(tasks.count - task.count), label: task.type)
                
                let dataSet = PieChartDataSet(entries: [completedEntry, remainingEntry], label: "Task Status")
                dataSet.colors = [task.color, .systemBlue]
                let data = PieChartData(dataSet: dataSet)
                data.setValueTextColor(.clear)
                
                pieChartView.data = data
                pieChartView.notifyDataSetChanged()
            }
            return
        }
    
        let dataSet = PieChartDataSet(entries: entries, label: "Task Status")
        dataSet.colors = colors
        
        let data = PieChartData(dataSet: dataSet)
        data.setValueTextColor(.clear)
        
        pieChartView.data = data
        pieChartView.notifyDataSetChanged()
    }

    // Helper function to assign color based on task type
    private func colorForTaskType(_ type: TaskManager.TaskType) -> UIColor {
        switch type {
        case .completed:
            return .systemGreen
        case .inProgress:
            return .systemYellow
        case .created:
            return .systemBlue
        case .upcoming:
            return .orange
        case .dueTasks:
            return .red
        default:
            return .systemBlue // Default color
        }
    }

    // Struct to hold task entry details
    private struct TaskEntry {
        let type: String
        let count: Int
        let color: UIColor
    }


}

