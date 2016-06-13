Excel = require( 'exceljs' )
# GREEN: FF92D050
# ORANGE: FFF8CBAD
# YELLOW: FFFFE699
# BLUE: FFB4C6E7
Meteor.methods(

  createReport: (customerName) ->
    check(customerName, Match.Any)

    csvWb = new Excel.Workbook()
    atlasReportData = new Array()
    csvWb.csv.readFile("../../../../../server/excel/uploadedReports/workbook1.csv")
        .then( (worksheet) ->
            # use workbook or worksheet
            worksheet.eachRow( (row, rowNumber) ->
                csvRowValues = []
                csvRowValues.push(row.values[1])
                csvRowValues.push(row.values[3])
                csvRowValues.push(row.values[5])
                atlasReportData.push(csvRowValues)
            )

            # create workbook by api
            workbook = new Excel.Workbook()
            workbook.creator = ''
            workbook.lastModifiedBy = ''
            workbook.created = new Date()
            workbook.modified = new Date()

            # create a sheet
            ws = workbook.addWorksheet("Existing Users")

            #set columns
            #access an individual columns by key, letter and 1-based column number
            ws.columns = [
                { header: 'Email Domain', key: 'domain', width: 30 },
                { header: 'User Email', key: 'email', width: 30 },
                { header: 'User ID', key: 'uid', width: 15 },
                { header: 'Name', key: 'name', width: 30 },
                { header: 'Account Type', key: 'acctType', width: 25 },
                { header: 'Enterprise ID', key: 'eid', width: 18 },
                { header: 'Registration Date', key: 'regDate', width: 20 },
                { header: 'Last Activity Date', key: 'lastAct', width: 20 },
                { header: 'Disabled by Box Date', key: 'disabledDate', width: 25 },
                { header: 'Days Active', key: 'daysActive', width: 18 },
                { header: 'Space Used (MB)', key: 'space', width: 20 },
                { header: 'Migration Status', key: 'status', width: 30 }
            ]

            # style header row
            headerRow = ws.getRow(1)

            headerRow.eachCell( (cell, colNumber) ->
                cell.font = {
                    size: 14,
                    italic: true,
                    bold: true
                }
                cell.alignment = { vertical: 'middle', horizontal: 'center' }
                cell.border = {
                    bottom: {style:'medium'}
                }
                cell.fill = {
                    type: 'pattern',
                    pattern:'solid',
                    fgColor:{argb:'FFD9D9D9'}
                }
            )

            ws.addRows(atlasReportData)

            ###
            #Add data
            rows = [
                [5,'Bob',new Date()], # row by array
                [6, 'Barbara', new Date()]
            ];
            ###



            # create xlsx file
            workbook.xlsx.writeFile("../../../../../server/excel/generatedReports/" + customerName + " User Report.xlsx").then( ->
              console.log(customerName + " User Report.xlsx has been written to file")
            )
        )




)
